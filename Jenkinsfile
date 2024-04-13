pipeline {
    agent any
    tools {
        maven "Maven-3.9"
    }
    environment{
        aws_repo=339712792713.dkr.ecr.us-east-1.amazonaws.com/java-maven
    }

    stages {
        stage("increment version") {
            steps {
                script {
                    echo "increment version..."
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.IMAGE_NAME = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage("build jar") {
            steps {
                script {
                    echo "Building app.."
                    sh "mvn clean package"
                }
            }
        }
        stage("build docker image") {
            steps {
                script {
                    echo "Building docker image.."
                    withCredentials([usernamePassword(credentialsId: 'aws_ecr', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "docker build -t ${aws_repo}:${IMAGE_NAME} ."
                        sh "docker login -u $USER -p $PASS 339712792713.dkr.ecr.us-east-1.amazonaws.com"
                        sh "docker push ${aws_repo}:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    echo "deploying in eks cluster.."
                    sh "envsubst < kubernetes/deployment.yaml | kubectl apply -f -"
                    sh "kubectl apply -f kubernetes/service.yaml"
                }
            }
        }
        stage("commit to github"){
            steps{
                script{
                    withCredentials([usernamePassword(credentialsId: 'GitCREADINTIALS1', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'git config --global user.name "jenkins"'
                        sh 'git config --global user.email "jenkins@example.com"'

                        sh "git status"
                        sh "git branch"

                        sh "git remote set-url origin https://${USER}:${PASS}@github.com/abanobmorkosgad/Jenkins.git"
                        sh "git add ."
                        sh "git commit -m 'ci: update pom and jar'"
                        sh "git push origin HEAD:k8s_ecr"
                    }
                }
            }
        }
    }
}