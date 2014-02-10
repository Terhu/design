#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char** argv)
{

	float latitude;           /*Coordonnée latitudinale*/
	float latitude1[2];       /*Coordonnée latitudinale en degrée*/
	float latitude2[7];       /*Coordonnée latitudinale en minute*/
	char latitudedirection;   /*Direction de la latitude*/
	float longitude;          /*Coordonnée longitudinale*/
	float longitude1[3];      /*Coordonnée longitudinale en degrée*/
	float longitude2[7];      /*Coordonnée longitudinale en minute*/
	char longitudedirection;  /*Direction de la longitude*/

	char v[10], poub[64];
	FILE * fchtxt ; /*Ouverture du fichier fchtxt en mode lecture*/
	FILE * fchkml ; /*Ouverture du fichier fchkml en mode ecriture s'il existe sinon création*/




	if (argc < 2)       /*Si les deux noms de fichier ne sont pas ou mal tapé*/
	{
		puts("main fichier.txt fichier.kml");
		
	}
	else               /*Sinon*/
	{
		//ouverture des fichiers
		fchtxt = fopen(argv[1],"r"); /*Ouverture du fichier fchtxt en mode lecture*/
		fchkml = fopen(argv[2],"w"); /*Ouverture du fichier fchkml en mode ecriture s'il existe sinon création*/


		fputs("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://earth.google.com/kml/2.2\">\n  <Document>\n    <name>\n",fchkml); /*Ecriture du début du fichier kml*/

		puts("Entrer un nom pour votre parcours :"); /*Ecriture du titre du parcours*/
		scanf("%s",v);
		fprintf(fchkml,"       %s\n",v);

		fputs("    </name>\n    <description>\n",fchkml);

		puts("Entrer un commentaire de votre parcours :"); /*Ecriture des commentaires du parcours*/
		scanf("%s",v);
		fprintf(fchkml,"       %s\n",v);

		fputs("    </description>\n    <Style id=\"yellowLineGreenPoly\">\n      <LineStyle>\n        <color>7f00ffff</color>\n        <width>4</width>\n      </LineStyle>\n      <PolyStyle>\n        <color>7f00ff00</color>\n      </PolyStyle>\n    </Style>\n    <Placemark>\n      <name>Absolute Extruded</name>\n",fchkml);
		fputs("      <description>Transparent green wall with yellow outlines</description>\n      <styleUrl>#yellowLineGreenPoly</styleUrl>\n      <LineString>\n        <extrude>1</extrude>\n        <tessellate>1</tessellate>\n        <altitudeMode>clampToGround</altitudeMode>\n        <coordinates>\n",fchkml);
//----------------------------------------------------------------------------------------------------------------
// format de la position filtrée et sauvegardée par le µC
        /*  4545.5322,N,00306.6839,E  */

		while(!feof(fchtxt)) /*tant que l'on est pas a la fin du fichier de lecture*/
		{
            
			fscanf(fchtxt,"%2f%7f%1c", latitude1, latitude2, v); /*enregistrement de la latitude*/
			
			latitude=*latitude1+*latitude2/60.0; /*conversion de la trame en format kml : lat1 + ( lat2 / 60.0 ) */
            if (strncmp(v,",",1) == 0) /*si la virgule est bien placée */
			      {
			        fscanf(fchtxt,"%1c%1c", &latitudedirection, v); /*enregistrement de la direction de la latitude*/
			        if (strncmp(v,",",1) == 0) /*si la virgule est bien placée*/
			        {
			          fscanf(fchtxt,"%3f%7f%1c", longitude1, longitude2, v); /*enregistrement de la longitude*/
			          longitude=*longitude1+*longitude2/60.0; /*conversion de la trame en format kml : long1 + ( long2 / 60.0 ) */
			          if (strncmp(v,",",1) == 0) /*si la virgule est bien placée*/
			          {
			            fscanf(fchtxt,"%1c%1c", &longitudedirection, v); /*enregistrement de la direction de la longitude*/

	// Ecriture de cette position dans le fichier kml
						fprintf( fchkml,"        ");
						if (strncmp(&longitudedirection,"O",1) == 0) /*test de direction de la longitude*/
								{
								fprintf( fchkml,"-"); /*si direction de la longitude est O on rajoute un "-"*/
								}
						fprintf( fchkml,"%f", longitude); /*inscription de la longitude sur le fichier kml*/
						fprintf( fchkml,",");
						if (strncmp(&latitudedirection,"S",1) == 0) /*test de direction de la latitude*/
								{
								fprintf( fchkml,"-");  /*si direction de la latitude est S on rajoute un "-"*/
								}
						fprintf( fchkml,"%f\n", latitude); /*inscription de la latitude sur le fichier kml*/


						//fscanf(fchtxt,"%s", poub); /*on passe la fin de la ligne*/
			          }
			        }
			      }
		}



		fputs("        </coordinates>\n      </LineString>\n    </Placemark>\n  </Document>\n</kml>\n",fchkml); /*Inscription de la fin du fichier kml*/
		printf("\n");
	    fclose(fchtxt); /*fermeture du fichier txt*/
        fclose(fchkml); /*fermeture du fichier kml*/

	}
	return 0;
}

