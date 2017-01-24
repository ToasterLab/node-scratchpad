app = new Vue(
	
  el: '#app'
  
  data:
    'title': 'Scratchpad'
    'subtitle': 'Dumping ground for your uninspired ramblings'
    'notice': 'This is a minimalist online scratchpad provided free of charge.'
    'secretcode': ''
    
  methods: retrieve: ->
    # speak with api
    @secretcode # return this.secretcode
)
