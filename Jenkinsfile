def gv
pipeline{
    agent any
    parameters{
        choice(name: 'Version', choices: ['1.0.1','1.0.2','1.0.3'], description: '')
        booleanParam(name: 'executeTest', defaultValue: true, description: '')
    }
    stages{
        stage("init"){
            steps{
                script{
                    gv = load "script.groovy"
                }
            }
        }
        stage("test"){
            when{
                expression{
                    params.executeTest == true
                }
            }
            steps{
                script{
                    gv.test()
                }
            }
        }
        stage("build"){
            steps{
                script{
                    gv.build()
                }
            }
        }
        stage("deploy"){
            input{
                message "select the environment to deploy to"
                ok "Done"
                parameters{
                    choice(name: 'Environment', choices: ['dev','test','prod'], description: '') 
                }
            }
            steps{
                script{
                    gv.deploy()
                    echo "deploying to ${Environment}"
                }
            }
        }
    }
}