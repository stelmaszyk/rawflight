#!/bin/bash

#metoda addstandarduser dodaje standardowego uzytkownika
addstandarduser()
{
  echo "Dodajesz uzytkownika. Zwroc uwage, czy haslo ktore wpisujesz jest poprawne, poniewaz nie bedzie go widac."
  read -p "Wprowadz nazwe uzytkownika" username
  echo " "
  # useradd dodaje uzytkownika o nazwie username, ktora wpisales wczesniej
  useradd $username
  echo "Teraz wprowadz haslo dla uzytkownika. Pamietaj - wprowadzane haslo nie bedzie widoczne."
  passwd $username
}

#metoda dodajaca administratora
addsuperuser()
{
  read -p "Wprowadz nazwe uzytkownika" username
  echo " " #odstep
  useradd $username
  read -p "Teraz wprowadz haslo dla uzytkownika. Pamietaj - wprowadzane haslo nie bedzie widoczne." password
  passwd $password
  sleep 2
  echo " "
  echo "Nadaje prawa administratora. Prosze czekac"
  usermod -aG sudo $username #nadaje uprawnienia sudoera
  sleep 2
  echo " "
  echo "Uprawnienia nadane. Aby sprawdzic, czy konto zostalo poprawnie utworzone wykonaj odpowiednio komendy: "
  echo "su - "$username
  echo "sudo whoami"
  echo " "
  echo "Jeśli sudo whoami zwroci komunikat o tresci: "
  echo "root"
  echo "to Skrypt zakonczyl prace. "

}

#metoda zmieniajaca haslo
changepwd()
{
  passwd #uruchamia aplikacje do zmiany lub nadania hasla.
}

#metoda usuwajaca uzytkownika
deleteuser()
{
  read -p "Wprowadz nazwe uzytkownika, ktorego chcesz usunac" username
  echo " "
  read -p "Usuwasz konto uzytkownika "$username", czy chcesz usunac takze jego katalog domowy? Wcisniecie klawisza t usuwa, kazdy inny usuwa tylko uzytkownika: " decision
  echo "Pamietaj! Tego kroku nie da sie odzyskac!"
  case "$decision" in
      "y") userdel -r $username
            echo "Konto uzytkownika zostalo usuniete wraz z katalogiem domowym";;
      *) userdel $username
            echo "Konto uzytkownika zostalo usuniete, ale jego katalog domowy zostal zachowany";;

}

#glowny program.
# Sprawdzimy, czy użytkwonik odpalający skrypt jest adminem, czyli ma uprawnienia superuser
if [ "$(whoami)" != "root" ]
  then echo "Uruchom skrypt jako administrator."

  else
    {
    echo "Menu: "
    echo "1. Dodaj uzytkownika standardowego"
    echo "2. Dodaj uzytkownika z uprawnieniami superuser"
    echo "3. Zmien haslo uzytkownika"
    echo "4. Usun uzytkownika"
    echo " "
    # To jest coś jak Console.ReadLine w C#
    read -p "Wprowadz wybor: " wybor
    # teraz przy uzyciu case stworzymy wybor opcji. kazda opcja odwola sie do funkcji
    case "$wybor" in
      "1") addstandarduser;; #dwa sredniki musza byc, inaczej interpreter nie wie, ze to koniec wyboru
      "2") addsuperuser;;
      "3") changepwd;;
      "4") deleteuser;;
      *) echo "Wybrano zla opcje. Zamykam program" exit 1;; # * oznacza wybranie innego klawisza
    esac #wszystkei funkcje logiczne zamykasz odwrocona nazwa. Case zamykasz esac, if zamykasz fi etc
  }
fi
