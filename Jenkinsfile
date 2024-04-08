pipeline {
    agent any
    tools {
        maven "Maven-3.9"
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
                    withCredentials([usernamePassword(credentialsId: 'DockerCred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh "docker build -t abanobmorkos10/java-maven:${IMAGE_NAME} ."
                        sh "docker login -u $USER -p $PASS"
                        sh "docker push abanobmorkos10/java-maven:${IMAGE_NAME}"
                    }
                }
            }
        }
        stage("deploy") {
            steps {
                script {
                    def dockerCommnad= "sudo docker run -p 8080:8080 -d abanobmorkos10/java-maven:${IMAGE_NAME}"
                    sshagent(['ec2-key']) {
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@18.233.225.26 sudo yum install -y docker"
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@18.233.225.26 sudo systemctl start docker"
                        withCredentials([usernamePassword(credentialsId: 'DockerCred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                            sh "ssh -o StrictHostKeyChecking=no ec2-user@18.233.225.26 sudo docker login -u $USER -p $PASS"
                        }
                        sh "ssh -o StrictHostKeyChecking=no ec2-user@18.233.225.26 ${dockerCommnad}"
                    }
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
                        sh "git push origin HEAD:versioning"
                    }
                }
            }
        }
    }
}
