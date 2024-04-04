def build() {
    echo "building .."
}
def test() {
    echo "testing .."
}
def deploy() {
    echo "deploying version ${params.Version}"
}
return this