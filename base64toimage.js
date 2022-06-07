exports("base64toimage", (path,rawBody) => {
  var base64Data = rawBody.replace(/^data:image\/jpeg;base64,/, "");
    require("fs").writeFile(path, base64Data, 'base64', function(err) {
      console.log(err);
    });
});