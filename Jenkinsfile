pipeline{
    agent any
    parameters{
        choice(name: 'Version', choices: ['1.0.1','1.0.2','1.0.3'], description: '')
        booleanParam(name: 'executeTest', defaultValue: true, description: '')
    }
    stages{
        stage("test"){
            when{
                expression{
                    params.executeTest == true
                }
            }
            steps{
                echo "testing.."
            }
        }
        stage("build"){
            steps{
                echo "building .."
            }
        }
        stage("deploy"){
            steps{
                echo "deploying version ${params.Version}"
            }
        }
    }
}