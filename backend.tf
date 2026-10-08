terraform {
    backend "s3" {
        key          = ""
        bucket       = "" 
        region       = "" 
        profile      = ""
        use_lockfile = true
        encrypt      = true
    }
}