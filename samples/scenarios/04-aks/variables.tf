variable aks_cluster_size {
    default = "small"
}
variable aks_service_offerings {
    type = map(object({
        # Starting Number of Nodes
        node_count     = number
        # Auto Scale Max Nodes
        node_max_count = number
        # Auto Scale Min Nodes
        node_min_count = number
        node_size = string 
    }))
}