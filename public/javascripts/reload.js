var milisec=0, seconds=60;
function display()
{ 
  if (milisec<=0){ 
    milisec=9;
    seconds-=1; 
  } 
  if (seconds<=-1){ 
    milisec=0;
    seconds+=1;
  } 
  else milisec-=1;
  document.getElementById("d2").innerHTML=seconds+"."+milisec;
  if (seconds <= 0 && milisec <= 0) location.reload();
  else setTimeout("display()",100);
}