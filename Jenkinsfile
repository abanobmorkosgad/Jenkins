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
                    def shellcmd="bash ./docker-cmd.sh abanobmorkos10/java-maven:${IMAGE_NAME}"
                    def ec2="ec2-user@34.227.28.46"
                    sshagent(['ec2-key']) {
                        sh "scp docker-cmd.sh ${ec2}:~"
                        sh "scp docker-compose.yaml ${ec2}:~"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2} ${shellcmd}"
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
                        sh "git push origin HEAD:Deploy-compose"
                    }
                }
            }
        }
    }
}
