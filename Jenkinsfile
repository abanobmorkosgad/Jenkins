#!/usr/bin/env groovy

@Library('jenkins-shared-library')
def gv 

pipeline {
    agent any
    tools {
        maven "Maven-3.9"
    }

    stages {
        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    buildJar()
                }
            }
        }
        stage("build and push docker image") {
            steps {
                script {
                    buildImage "abanobmorkos10/java-maven:3"
                    dockerLogin()
                    pushImage "abanobmorkos10/java-maven:3"
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
}