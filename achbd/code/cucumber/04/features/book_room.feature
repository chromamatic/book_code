# language:en
Feature: Book room
  In order to attract more people
  Travelers should be able to book on the web
  
  Background
    Given a hotel with "5" rooms and "0" bookings

  Scenario: Request for one room
    When I ask to book "1" room at the hotel
    # ...

  Scenario: Request too many rooms
    When I ask to book "6" rooms at the hotel
    # ...

