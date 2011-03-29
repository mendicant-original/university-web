// UW.Slugger

UW.setupNamespace("Slugger");

UW.Slugger.watch = function(sourceField, destinationField){
  sourceField      = $('#' + sourceField);
  destinationField = $('#' + destinationField);
  
  sourceField.keyup(function(e){    
    UW.Slugger.generate(sourceField.val(), function(data){
      destinationField.val(data);
    })
  });
}

UW.Slugger.generate = function(text, callback){
  console.debug(text);
  
  $.get("/slugger", {'text': text}, function(data){
    callback(data);
  });
}