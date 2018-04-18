# bones = Term.new(term: "bones")
# graveyard = Term.new(term: "graveyard")
# island = Term.new(term: "island")
# food = Term.new(term: "food")

areax = Article.new(title: "Area X", content: "What lies beyond the border?", url: "http://a.co/aJJk31s")
anni = Article.new(title:"Annihilation", content:"First book in the trilogy", url: "http://a.co/3TK1fYs")
auth = Article.new(title:"Authority", content:"Second book in the trilogy", url: "http://a.co/40Jdjeg")
acc = Article.new(title: "Acceptance", content: "Third book in the trilogy", url: "http://a.co/e5jBHi4")
areax.save
anni.save
auth.save
acc.save
