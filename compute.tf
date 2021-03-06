module "resourcegroup" {
  source  = "app.terraform.io/HelloWorldInc/resourcegroup/azurerm"
  version = "0.0.1"
  
  rsrc_name     = "RGWEBSITE01PROD"
  rsrc_location = "East US 2" 
}

module "staticsite" {
  source  = "app.terraform.io/HelloWorldInc/staticsite/azurerm"
  version = "0.0.3"
 
  rsrc_location   = "East US 2"
  rsrc_name       = "ststwebsprd01"
  rsrc_rg         =  module.resourcegroup.rg_name
  rsrc_skugeneral = "Standard"
}
  
#######Resources needed to Alert Static Site using Azure Monitor
  
resource "azurerm_log_analytics_workspace" "loganalytics" {
  name                = "lganwebsprd01"
  location            = "East US 2"
  resource_group_name = module.resourcegroup.rg_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
  
resource "azurerm_application_insights" "appinsights" {
  name                = "apinwebsprd01"
  location            = "East US 2"
  resource_group_name = module.resourcegroup.rg_name
  workspace_id        = azurerm_log_analytics_workspace.loganalytics.id
  application_type    = "web"
}
  
resource "azurerm_application_insights_web_test" "webtest" {
  name                    = "webtest-static-web-prod"
  location                = "East US 2"
  resource_group_name     = module.resourcegroup.rg_name
  application_insights_id = azurerm_application_insights.appinsights.id
  kind                    = "ping"
  frequency               = 300
  timeout                 = 60
  enabled                 = true
  geo_locations           = ["us-tx-sn1-azr", "us-il-ch1-azr"]

  configuration = <<XML
<WebTest Name="WebTest1" Id="ABD48585-0831-40CB-9069-682EA6BB3583" Enabled="True" CssProjectStructure="" CssIteration="" Timeout="0" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description="" CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False" RecordedResultFile="" ResultsLocale="">
  <Items>
    <Request Method="GET" Guid="a5f10126-e4cd-570d-961c-cea43999a200" Version="1.1" Url="https://${module.staticsite.rsrc_url}" ThinkTime="0" Timeout="300" ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False" ResponseTimeGoal="0" Encoding="utf-8" ExpectedHttpStatusCode="200" ExpectedResponseUrl="" ReportingName="" IgnoreHttpStatusCode="False" />
  </Items>
</WebTest>
XML
    
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}  
  
resource "azurerm_monitor_metric_alert" "metricalert" {
  name                = "Alert Static Web App Prod"
  resource_group_name = module.resourcegroup.rg_name
  scopes              = [azurerm_application_insights_web_test.webtest.id, azurerm_application_insights.appinsights.id]
  description         = "Action will be triggered when Static Web App is down"
    
  application_insights_web_test_location_availability_criteria {
    web_test_id           = azurerm_application_insights_web_test.webtest.id
    component_id          = azurerm_application_insights.appinsights.id
    failed_location_count = "2"
  }
    
  action {
    action_group_id = azurerm_monitor_action_group.actiongroup.id
  }
}  

resource "azurerm_monitor_action_group" "actiongroup" {
  name                = "actiongroupOpsTeams"
  resource_group_name = module.resourcegroup.rg_name
  short_name          = "OpsTeams"

  email_receiver {
    name          = "SendToOpsTeam"
    email_address = "christian.tineo.528@gmail.com"
  }
}
