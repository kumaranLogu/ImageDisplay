function sendImage(){
    var message = {"cmd":"increment","count":"1","callbackFunc":function(responseAsJSON){
        var response = JSON.parse(responseAsJSON)
        image = response['image']
        var element = document.createElement("img");
        element.src = image;
        element.width = 276;
        element.height = 110;
        element.alt = "custom";
        if(image) {
            document.querySelector("#messagesImage").appendChild(element);
        }
        document.getElementById("buttonClick").disabled = true;
    }.toString()}
    native.postMessage(message)
}
