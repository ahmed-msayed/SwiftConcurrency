//
//  SwiftClassActor.swift
//  SwiftConcurrencyCourse
//
//  Created by Ahmed Sayed on 01/11/2024.
//

/*
VALUE TYPES:
    - Struct, Enum, String, Int, etc.
    - Stored in the Stack
    - Faster
    - Thread Safe
    - When you assign or pass value type a new copy of data is created
 
REFERENCE TYPES:
    - Class, Function, Actor
    - Stored in the Heap
    - Slower, but synchronized
    - NOT Thread safe
    - When you assign or pass reference type a new reference to original instance will be created (pointer)

STACK:
    - Stores Value types
    - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast
    - Each thread has it's own stack!
 
HEAP:
    - Stores Reference types
    - Shared across threads!

STRUCT:
    - Based on VALUES
    - Can me mutated
    - Stored in the Stack!
 
CLASS:
    - Based on REFERENCES (INSTANCES)
    - Stored in the Heap!
    - Inherit from other classes
 
ACTOR:
- Same as Class, but thread safe!

Usage:
Structs:    Data Models, Views
Classes:    ViewModels
Actors:     Shared 'Manager' and 'Data Stores'

 */
 
import SwiftUI

struct StructClassActor: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                runTest()
            }
    }
}

#Preview {
    StructClassActor()
}


extension StructClassActor {
    private func runTest() {
        print("Test Started.")
        structTest1()
        printDivider()
        classTest1()
        printDivider()
        actorTest1()
//        structTest2()
//        printDivider()
//        classTest2()
    }
    
    private func printDivider() {
        print("""
            
            "-----------------------------------------------------------------------------"
            
            """)
    }
    
    func structTest1() {
        let objectA = MyStruct(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("pass the values of objectA to objectB")
        var objectB = objectA               // var cuz we change the entire object
        print("ObjectB: ", objectB.title)
        print("ObjectB Title Changed.")
        
        objectB.title = "Second Title!"     //changes B only with new data
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    func classTest1() {
        let objectA = MyClass(title: "Starting Title!")
        print("ObjectA: ", objectA.title)
        
        print("pass a reference of objectA to objectB")
        let objectB = objectA               // let cuz we change only the data inside it
        print("ObjectB: ", objectB.title)
        print("ObjectB Title Changed.")
        
        objectB.title = "Second Title!"     // change referenced data, so changes the source, so changes both
        print("ObjectA: ", objectA.title)
        print("ObjectB: ", objectB.title)
    }
    
    private func actorTest1() {
        Task {
            let objectA = MyActor(title: "Starting Title!")
            await print("ObjectA: ", objectA.title)
            
            print("pass a reference of objectA to objectB")
            let objectB = objectA               // let cuz we change only the data inside it
            await print("ObjectB: ", objectB.title)
            print("ObjectB Title Changed.")
            
            //        objectB.title = "Second Title!"     // change referenced data, so changes the source, so changes both //error on Actor
            await objectB.updateTitle(newTitle: "Second Title!")
            await print("ObjectA: ", objectA.title)
            await print("ObjectB: ", objectB.title)
        }
    }
}

struct MyStruct {
    var title: String
}

//immutable struct
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct { //replace current struct with new one
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    private(set) var title: String  //can only setted from inside "updateTitle"
    
    init(title: String) {
        self.title = title
    }
    
    mutating func updateTitle(newTitle: String) { //creating new struct with this new values
        title = newTitle
    }
}

extension StructClassActor {
    private func structTest2() {
        print("structTest2")
        
        //mutating struct
        var struct1 = MyStruct(title: "Title1")
        print("struct1: ", struct1.title)
        struct1.title = "Title2"
        print("struct1: ", struct1.title)
        
        //changing an immutable struct by created a totally separate struct
        var struct2 = CustomStruct(title: "Title1")
        print("struct2: ", struct2.title)
        struct2 = CustomStruct(title: "Title2")
        print("struct2: ", struct2.title)

        //changing by using a function to create new struct with the new value
        var struct3 = CustomStruct(title: "Title1")
        print("struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "Title2")
        print("struct3: ", struct3.title)

        //changing by a mutating function
        var struct4 = MutatingStruct(title: "Title1")
        print("struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "Title2")
        print("struct4: ", struct4.title)
    }
}



class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActor {
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "Title1")
        print("class1: ", class1.title)
        class1.title = "Title2"
        print("class1: ", class1.title)
        
        let class2 = MyClass(title: "Title1")
        print("class2: ", class2.title)
        class2.updateTitle(newTitle: "Title2")
        print("class2: ", class2.title)
    }
}
