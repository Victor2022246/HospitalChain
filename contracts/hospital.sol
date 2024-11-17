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
 mapping(address => bool) public registeredDoctors; // Addresses of doctors who are approved serch by accound number 


// EVENTS to be emmited during certain actions, helpful for tracking in the block chain
event ServiceMenuAdded(uint serviceId, string serviceName, uint price, string doctor); //Emmited when a new service is added 
event AppointmentMade(address pacient, uint serviceId, uint date, uint totalCost, string doctor, string treatmentDetails); // emmited when appointment is made
event PaymentReceived(address pacient, uint amount, uint date); //emmited when payment is received
event PatientRegistration (address patient, string patientName, uint age, bool registered);// emmited when patient is created


// modifier to restric the actions to the adiministrator
modifier onlyAdmin(){
require(msg.sender == administrator, "only the admin can perform this action.");// check the function caller is the admin
_;//continue the function execution

}

modifier patientRegistered(address _patient) { // checks if the patient is registered to the hospital 
        require(patients[_patient].registered, "This patient is not registered and couldant be fund");
        _;
    }

    modifier onlyDoctor() { // modifier to check if the doctor is registered
        require(registeredDoctors[msg.sender], "you must be a registered doctor to perfor this action");
        _;


    }



constructor(){
    administrator = msg.sender; //set the contract deployer as the admin
}

// function to add a new service to the list
function addServiceMenu (string memory _serviceName, uint _price, string memory _doctorName ) public onlyAdmin {
// create a nue menu appointment and store in the map
services[serviceMenuCount]= servicesMenu(_serviceName, _price, _doctorName  );
emit ServiceMenuAdded(serviceMenuCount, _serviceName, _price, _doctorName);// emmits the information of the appointment added to the service list 
serviceMenuCount++; // increments the count of existing services 
}


// function to  Create a new patient profile
    function RegisterPatient(string memory _patientName,  string memory _medHistory, uint256 _age, bool _registered) public {
        require(!patients[msg.sender].registered, "Patient profile already exists");

        patients[msg.sender] = Patient({
            patientName: _patientName,
             medHistory:_medHistory,
           age: _age,
           registered: true}
        
        );
  emit PatientRegistration(msg.sender, _patientName, _age, _registered);// emits the created patient 

    }






//function to place an appointment to specific  service making sure patient is registered
function makeAppointment (uint _serviceId, string memory _patientName , string memory _treatmentDetails, uint _date, string memory _doctor  ) public payable patientRegistered(msg.sender) {
require(_serviceId < serviceMenuCount, "Invalid service");// ensure the service exists is valid
servicesMenu memory service = services[_serviceId]; // get the information from the appointments menu by index as an array of objects
uint totalCost = service.price;
require(msg.value == totalCost, "incorrect payment amount."); // ensure the amount to be paid is right
AppointmentSchedule[appointmentCount]= Appointment(msg.sender, _patientName, totalCost , _treatmentDetails, _serviceId, _date , _doctor );


adminBalance += msg.value; // update owners balance with the amount paid 
emit AppointmentMade ( msg.sender, _serviceId, _date, totalCost, _doctor, _treatmentDetails);
emit PaymentReceived(msg.sender, msg.value, _date);
}





}