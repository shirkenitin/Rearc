# module "iam" {
#   source = "./modules/iam"


#   environment       = var.environment
#   project_name      = var.project_name
#   ecs_exec_logs_arn = module.ecs.ecs_exec_logs_arn
#   tags              = local.common_tags

# }

# module "ecs" {
#   source = "./modules/ecs"


#   environment                 = var.environment
#   region                      = var.region
#   project_name                = var.project_name
#   vpc_id                      = var.vpc_id
#   ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
#   tags                        = local.common_tags

# }