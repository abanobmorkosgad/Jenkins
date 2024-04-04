def gv 
pipeline {
    agent any
    tools {
        maven "Maven-3.9"
    }

    stages {
        stage("init"){
            steps{
                script{
                    gv = load "script.groovy"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    gv.buildjar()
                }
            }
        }
        stage("build docker image") {
            steps {
                script {
                    gv.buildimage()
                    }
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    gv.deploy()
                }
            }
        }
    }


