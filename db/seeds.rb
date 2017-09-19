user1 = User.create(name: "John Applesauce", email: "test@gmail.com", password: "password", password_confirmation: "password", admin: false)
user2 = User.create(name: "Admin", email: "admin@escapelounge.com", password: "password", password_confirmation: "password", admin: true)


game1 = Game.create(name: "The Escape Room Game", description: "This is an awesome game description", visible: false)
game2 = Game.create(name: "Can You Name All 50 States?", description: "This is an awesome game description", visible: true)


game_step1 = GameStep.create(name: "Feeling a little blue...", description: "I come and I go, I sing high and low, when I'm around all stop to hear, and when I am gone everyone begins to fear. Being that I am blue, and round, what kind of animal am I to wear a crown?", game_id: 2)
game_step2 = GameStep.create(name: "Things will get better, right?.", description: "When I am alone I cry, and when I am with the lions I roar high, yet when I am with you I want to fry banana cheesecake, and that worries my mother who much prefers banane beefcake.", game_id: 2)


hint1 = Hint.create(description: "I am a bird with long beige beak, and I only sign when I speak", value: -5, game_step_id: 1)
hint2 = Hint.create(description: "If the hint before is not enough, then your brain must be full of fluff", value: -8, game_step_id: 1)
