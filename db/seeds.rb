c1 = Checkpoint.create(name: "Chicago", open: true)
Message.create(checkpoint_id: c1.id, body: "Chicago is open")
Message.create(checkpoint_id: c1.id, body: "Chicago is open")
Message.create(checkpoint_id: c1.id, body: "Chicago is open")
c2 = Checkpoint.create(name: "New York", open: false)
Message.create(checkpoint_id: c2.id, body: "New York is false")
Message.create(checkpoint_id: c2.id, body: "New York is open")


en = File.readlines('checkpoints.txt')
ar = File.readlines('checkpoints_ar.txt')

combined = en.zip ar

combined.each do |line|
  Checkpoint.create name: line.first, ar: line.last, open: false
end
