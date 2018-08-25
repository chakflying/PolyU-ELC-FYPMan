$(function(){
    var x = document.getElementsByClassName("site-alert");
    var i;
    for (i = 0; i < x.length; i++) {
        console.log(x[i]);
        x[i].onclick = function(self) {
            console.log(self.target);
            self.target.classList.add("animated", "zoomOutUp");
        };
    }
});