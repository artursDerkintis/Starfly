window.onload = function () {
    document.body.style.webkitTouchCallout='none';
    
}
window.onpageshow = function () {
}
function getHTMLElementsAtPoint(x,y) {
    var tags = "";
    var e = document.elementFromPoint(x,y);
    while (e) {
        if (e.tagName) {
            var name = e.tagName.toUpperCase();
            if (name == 'A') {
                tags += 'A[' + e.href + ']|&|';
            } else if (name == 'IMG') {
                tags += 'IMG[' + e.src + ']|&|';
            }
        }
        e = e.parentNode;
        
    }
    return tags;
}
function savePassword() {
    var node_list = document.getElementsByTagName('input');
    var tags = "";
    for (var i = 0; i < node_list.length; i++) {
        var node = node_list[i];
        
        if (node.getAttribute('type') == 'text' || node.getAttribute('type') == 'email') {
            if (node.value == null || node.value != ""){
                // do something here with a <input type="text" .../>
                // we alert its value here
                tags += 'USERNAME[' + node.value + ']|&|';
            }
        }
        if (node.getAttribute('type') == 'password'){
            if (node.value == null || node.value != ""){
                tags += 'PASSWORD[' + node.value + ']|&|';
            }
            
            
            
        }
    }
    return tags
    
}

function injectPassword(usernamre, passworrd) {
    var textNode;
    var passwordNode;
    setUserName(usernamre);
    setPassword(passworrd);
    
    
}
function setPassword(password){
    var node_list = document.getElementsByTagName('input');
    for (var i = 0; i < node_list.length; i++){
        var node = node_list[i];
        if (node.getAttribute('type') == 'password'){
            
            node.value = password;
            return;
            
        }
        
    }

}
function setUserName(username){
    var node_list = document.getElementsByTagName('input');
    
    for (var i = 0; i < node_list.length; i++) {
        var node = node_list[i];
        
        if (node.getAttribute('type') == 'text' || node.getAttribute('type') == 'email') {
            
            node.value = username;
            return;
            
        }
        
    }

}
function stopAllVideos(){
    var element = document.getElementById('player');
    if (!element){
        element = document.getElementsByTagName('video')[0];
    }
    
    element.outerHTML = "";
    delete element;
    
}
