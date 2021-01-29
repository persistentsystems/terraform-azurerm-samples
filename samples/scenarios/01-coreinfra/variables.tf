variable logs_short_term_days {
    description = "Number of days to hold logs in short term storage (Log Analytics)"
    default = 30 
}
variable logs_long_term_days {
    description = "Number of days to hold logs in short term storage (Azure Storage)"
    default = 90
}