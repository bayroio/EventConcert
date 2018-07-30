pragma solidity ^0.4.24;

contract EventConcert {
   address owner;
   uint numTicketsToSale;
   string description;
   string website;
   uint constant price = 1 ether;
   mapping (address => uint) public purchasers;
   
   event NoSePudoComprarBoleto(string);
   event NoSePudoRegresarCostoBoleto(string);
   
   constructor(uint _numTicketsToSale, string _description, string _website) public {
       owner = msg.sender;
       description = _description;
       numTicketsToSale = _numTicketsToSale;
       website = _website;
   }
   
   modifier OnlyBy()
   {
       if (owner != msg.sender)
        revert();
       _;
   }
   
   function infoEvent() public view returns (address, string, uint, uint) {
       return (owner, description, numTicketsToSale, price);
   }
   
   function buyTickets(uint amount) payable public {
       if (msg.value < (amount * price) || amount > numTicketsToSale) {
           emit NoSePudoComprarBoleto("No se pudo comprar el boleto");
           revert();
       }
       if (msg.value > (amount * price)) {
           msg.sender.transfer(msg.value - (amount * price));
       }
       purchasers[msg.sender] += amount;
       numTicketsToSale -= amount;
   }
   
   function refund(uint numTickets) public {
       if (purchasers[msg.sender] < numTickets) {
           emit NoSePudoRegresarCostoBoleto("No se puede regresar el costo del boleto");
           revert();
       }
       msg.sender.transfer(numTickets * price);
       purchasers[msg.sender] -= numTickets;
       numTicketsToSale += numTickets;
   }
   
   function EndSale() OnlyBy() public{
       owner.transfer(address(this).balance);
       
   }
}