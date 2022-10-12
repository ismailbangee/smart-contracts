// SPDX-License-Identifier: MIT
// Student management system which stores the data of students and we can retrive the data with the help of student ID.


pragma solidity ^0.8.9;

contract StudentManagement{
struct Student{
    int student_id;
    string  student_name;
    string student_dept;


}
    Student[] public Students;
    function addStudent(int id, string memory name, string memory dept) public {
        Student memory student_temp=Student(id,name,dept);
        Students.push(student_temp);
    }
    function findStudent(int id) public view returns(string memory name, string memory department){

            for(uint i=0;i<Students.length;i++){
                if(Students[i].student_id==id){
                    return(Students[i].student_name,Students[i].student_dept);
                }
            }

            return("Not Found", "Not found");

    }
    function getAllStudents() public view returns(Student[] memory studentList){
        return(Students);
    }




}
