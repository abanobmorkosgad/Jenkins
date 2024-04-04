pipeline {
    agent any
    tools {
        maven "Maven-3.9"
    }

    stages {
        stage("build jar") {
            steps {
                script {
                    echo "Building app.."
                    sh "mvn package"
                }
            }
        }
        stage("build docker image") {
            steps {
                script {
                    echo "Building docker image.."
                    withCredentials([usernamePassword(credentialsId: 'DockerCred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "docker build -t abanobmorkos10/java-maven:1.2 ."
                        sh "docker login -u $USER -p $PASS"
                        sh "docker push abanobmorkos10/java-maven:1.2"
                    }
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploying.."
                }
            }
        }
    }
}

