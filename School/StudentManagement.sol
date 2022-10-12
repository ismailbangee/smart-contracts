// SPDX-License-Identifier: MIT
// Student management system which stores the data of students and we can retrive the data with the help of student ID.


pragma solidity ^0.8.9;

// created a new Solidity contract named 'StudentManagement'
contract StudentManagement{
// struct Student to create a structure of student which contains ID, Name and Department
struct Student{
    int student_id;
    string  student_name;
    string student_dept;


}
// creating student struct object
    Student[] public Students;
    
    // function addStudent to add student to the list of students in a class
    function addStudent(int id, string memory name, string memory dept) public {
        Student memory student_temp=Student(id,name,dept);
        Students.push(student_temp);
    }
    
    // function find student to search if the student is in the class and return its data. 
    function findStudent(int id) public view returns(string memory name, string memory department){

            for(uint i=0;i<Students.length;i++){
                if(Students[i].student_id==id){
                    return(Students[i].student_name,Students[i].student_dept);
                }
            }

            return("Not Found", "Not found");

    }
    
    // function getAllStudents to get the data of all students in a class. 
    function getAllStudents() public view returns(Student[] memory studentList){
        return(Students);
    }




}
