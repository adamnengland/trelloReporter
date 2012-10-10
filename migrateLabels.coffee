Trello = require("node-trello")
t = new Trello("<KEY>", "<TOKEN>")
t.get "1/boards/501aae06c69a7d65341c8ba3/cards", (err, data) ->
  i = 0
  for x in data
  	for label in x.labels
  		if label.color == 'red'
  				console.log 'found it'
  				t.del "1/cards/#{x.id}/labels/red", ->
  					console.log 'delete complete'
  				t.post "1/cards/#{x.id}/labels", {value : "purple"}, (a,b)->
  					console.log 'post complete'
  				#console.log x.id
  			i++
  console.log i

