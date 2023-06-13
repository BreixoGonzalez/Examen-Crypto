//Breixo Ganaël GONZALEZ NOËL
// M1 Cybersécurité Ynov (Aix-en-Provence)
pragma solidity ^0.8.4;

contract Marketplace {
    // Enumération des états possibles de l'expédition
    enum ShippingStatus {Pending, Shipped, Delivered}

    // Initialisation du statut à Pending
    ShippingStatus public status = ShippingStatus.Pending;

    // Adresse du propriétaire
    address payable private proprietaire;

    // prix consultation du statut (en wei, 1 Ether = 10^18 wei)
    uint public prixConsultation = 10;

    // Colis expédié
    event PackageShipped(address indexed proprietaire, uint date);

    // Colis livré
    event MissionComplete(address indexed proprietaire, uint date);

    // Le propriétaire
    constructor() {
        proprietaire = payable(msg.sender);
    }

    // statut à Shipped
    function Shipped() public {
        require(msg.sender == proprietaire, "Seul le proprietaire peut expedier le colis");
        status = ShippingStatus.Shipped;
        emit PackageShipped(proprietaire, block.timestamp);
    }

    // statut à Delivered
    function Delivered() public {
        require(msg.sender == proprietaire, "Seul le proprietaire peut livrer le colis");
        status = ShippingStatus.Delivered;
        emit MissionComplete(proprietaire, block.timestamp);
    }

    // obtenir le statut de l'envoi
    function getStatus() public view returns (ShippingStatus) {
        require(msg.sender == proprietaire, "Seul le proprietaire peut consulter le statut");
        return status;
    }

    // permettre au client de récupérer le statut de la commande (payant)
    function Status() public payable returns (ShippingStatus) {
        require(msg.value >= prixConsultation, "Ethers insufissants pour consulter le statut");
        return status;
    }

    // permettre au propriétaire de retirer les Ethers accumulés
    function retirer() public {
        require(msg.sender == proprietaire, "Seul le proprietaire peut retirer les Ethers");
        uint montant = address(this).balance;
        (bool success, ) = proprietaire.call{value: montant}("");
        require(success, "Echec du transfert des Ethers");
    }
}
