def buildjar() {
    echo "Building app.."
    sh "mvn package"
}
def buildimage() {
    echo "Building docker image.."
    withCredentials([usernamePassword(credentialsId: 'DockerCred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
        sh "docker build -t abanobmorkos10/java-maven:1.2 ."
        sh "docker login -u $USER -p $PASS"
        sh "docker push abanobmorkos10/java-maven:1.2"
    }
}
def deploy() {
    echo "deploying.."
}
return this