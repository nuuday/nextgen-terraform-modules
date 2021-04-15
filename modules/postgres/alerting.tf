

resource "aws_cloudwatch_metric_alarm" "free_storage_alert" {
  alarm_name          = "${var.name}-free-storage-alert"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "300"
  statistic           = "Average"
  threshold           = var.free_storage_alert_limit
  dimensions = {
    DBInstanceIdentifier = var.name
  }
  alarm_description         = "Free storage of ${var.name} database is below threshold"
  insufficient_data_actions = []
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
}

resource "aws_cloudwatch_metric_alarm" "connection_alert" {
  alarm_name          = "${var.name}-connections-above-threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = var.connection_limit
  dimensions = {
    DBInstanceIdentifier = var.name
  }
  alarm_description         = "open connections towards ${var.name} database has reached the threshold"
  insufficient_data_actions = []
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
}

resource "aws_cloudwatch_metric_alarm" "CPU_threshold" {
  alarm_name          = "${var.name}-cpu-above-threshold"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "120"
  statistic           = "Average"
  threshold           = var.cpu_threshold
  dimensions = {
    DBInstanceIdentifier = var.name
  }
  alarm_description         = "CPU usage of ${var.name} database has reached threshold"
  insufficient_data_actions = []
  alarm_actions       = var.sns_topic_arn
  ok_actions          = var.sns_topic_arn
}