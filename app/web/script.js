var xmlhttp = new XMLHttpRequest();
xmlhttp.onreadystatechange = function() {
  if (this.readyState == 4 && this.status == 200) {
    var api_info = JSON.parse(this.responseText);
    document.getElementById("info").innerHTML = `Host: ${api_info.hostname}`
  }
};
xmlhttp.open("GET", "http://localhost:8080/api/v1/info", true);
xmlhttp.send();