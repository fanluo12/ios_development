
class Bird {
    
    var isFemale = true
    
    func layEgg() {
        if isFemale {
            print("The bird makes a new bird")
        }
    }
    func fly() {
        print("The bird flaps its wings to the sky")
    }
}

class Eagle: Bird {
    func soar() {
        print("The eagle glides in the air using air currents")
    }
}

let myEagle = Eagle()
myEagle.fly()
myEagle.soar()

class Penguin: Bird {
    func swim() {
        print("The penguin can swim")
    }
}

let myPenguin = Penguin()
myPenguin.swim()
myPenguin.fly()


struct FlyingMuseum {
    func flyingDemo(flyingObject: Bird) {
        flyingObject.fly()
    }
}

let meseum = FlyingMuseum()
meseum
