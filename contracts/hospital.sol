//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//Define the hospital contract 
contract Hospital{
    //Variable to store the administrator address
address public administrator;
//keeps traking of the hospital administration balance within the contract
uint public adminBalance;

//define the structure of the apoitments menu;
struct servicesMenu{

    string serviceName; // name of the service done by the hospital
    uint price;  //price for the service 
    string doctorName;
    uint date;
}
struct Patient{    // structure for creationm of a Patient 

 string patientName;
 string medHistory;
 uint age;
 bool registered; // bollean to test if the patient is registered before making and appointment 
}

struct Appointment { // structure the appointments schedule  
        address patient;
        string patientName;
        uint256 amount;
        string treatmentDetails;
        uint serviceId;
        uint date;
        string doctor;}



        
        //Mapping to store the appointments information, and access the by id  
mapping(uint => servicesMenu) public services;
uint public serviceMenuCount; //Counter for menu items, used to assing unique ID

mapping(address => Patient) public patients;

mapping(uint => Appointment) public AppointmentSchedule;// mapping the insurance claims to a array search by patient account
uint public appointmentCount;
 mapping(address => bool) public RegisteredDoctors; // Addresses of doctors who are approved serch by accound number 


// EVENTS to be emmited during certain actions, helpful for tracking in the block chain
event ServiceMenuAdded(uint serviceId, string serviceName, uint price, string doctor); //Emmited when a new service is added 
event AppointmentMade(address pacient, uint serviceId, uint date, uint totalCost, string doctor, string treatmentDetails); // emmited when appointment is made
event PaymentReceived(address pacient, uint amount, uint date); //emmited when payment is received
event PatientRegistration (address patient, string patientName, uint age, bool registered);// emmited when patient is created








}