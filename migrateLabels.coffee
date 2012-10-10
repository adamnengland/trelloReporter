Trello = require("node-trello")
t = new Trello("81fd0bf0fb6e8d3768e0635d89b2d463", "2e14f405729f06829cb87036214123237112e0ba746c5cafc30811fab9e547e5")
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

