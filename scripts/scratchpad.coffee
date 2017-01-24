Vue.http.interceptors.push (request, next) =>
	next (response) =>
		response.body = JSON.parse response.body
		# necessary, otherwise will overwrite response by returning response.body instead of response
		return

app = new Vue(
	
  el: '#app'
  
  data:
    'title': 'Scratchpad'
    'subtitle': 'Dumping ground for your uninspired ramblings'
    'notice': 'This is a minimalist online scratchpad provided free of charge.'
    'secretcode': ''
    'file':
    	'title':''
    	'message':''
    
  methods: retrieve: ->
    # speak with api
    @$http.get("/view/"+@.secretcode)
    	.then(
	    	(data) =>
	   			@file.title = @.secretcode
	   			@file.message = data.body.message
	   		,(err) =>
	   			console.log err
	   	)
)

Vue.component "scratch-piece", {
	props: ["file"]
	template: '
	<article class="message">
		<div class="message-header">
			<p>{{ file.title }}</p>
		</div>
		<div class="message-body">{{ file.message }}</div>
	</article>'
}