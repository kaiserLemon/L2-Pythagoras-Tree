//###########################################################################################################################
//=====================================================  Bibliothèques  =====================================================
//###########################################################################################################################
import peasy.*;


//###########################################################################################################################
//===================================================  Variables globales  ==================================================
//###########################################################################################################################
int _nbIter = 10; // Le niveau de récursion de l'arbre /!\ ne pas mettre au dessus de 10 /!\
PeasyCam _cam;


//###########################################################################################################################
//=======================================================  Fonctions  =======================================================
//###########################################################################################################################

//---------------------------------------------------------------------------------------------------------------------------
/* Rôle : trace les six faces d'un cube en fonction de ses 8 sommets
 * Entrée(s) : les 8 sommets d'un cube, la couleur des faces
 * Sortie : aucune
 * Précondition(s) : l'ordre des sommets doit être entré comme suit (on suppose un cube comme étant la réunion de deux carrés)
   - a : le sommet haut gauche du premier carré
   - b : le sommet haut droit du premier carré
   - c : le sommet bas droit du premier carré
   - d : le sommet bas gauche du premier carré
   - e : le sommet haut gauche du deuxième carré
   - f : le sommet haut droit du deuxième carré
   - g : le sommet bas droit du deuxième carré
   - h : le sommet bas gauche du deuxième carré
   "hueMod" ne doit pas dépasser la valeur maximale du paramètre HSB choisi (ici 100)
 */
void tracerSixFaces (PVector a, PVector b, PVector c, PVector d, PVector e, PVector f, PVector g, PVector h, float R, float G, float B)
{
  noStroke();
  fill(R, G, B);
  
  beginShape();
  vertex(a.x, a.y, a.z);
  vertex(b.x, b.y, b.z);
  vertex(c.x, c.y, c.z);
  vertex(d.x, d.y, d.z);
  endShape(CLOSE);
  
  beginShape();
  vertex(e.x, e.y, e.z);
  vertex(f.x, f.y, f.z);
  vertex(g.x, g.y, g.z);
  vertex(h.x, h.y, h.z);
  endShape(CLOSE);
  
  beginShape();
  vertex(a.x, a.y, a.z);
  vertex(b.x, b.y, b.z);
  vertex(f.x, f.y, f.z);
  vertex(e.x, e.y, e.z);
  endShape(CLOSE);
  
  beginShape();
  vertex(a.x, a.y, a.z);
  vertex(e.x, e.y, e.z);
  vertex(h.x, h.y, h.z);
  vertex(d.x, d.y, d.z);
  endShape(CLOSE);
  
  beginShape();
  vertex(b.x, b.y, b.z);
  vertex(c.x, c.y, c.z);
  vertex(g.x, g.y, g.z);
  vertex(f.x, f.y, f.z);
  endShape(CLOSE);
  
  beginShape();
  vertex(d.x, d.y, d.z);
  vertex(c.x, c.y, c.z);
  vertex(g.x, g.y, g.z);
  vertex(h.x, h.y, h.z);
  endShape(CLOSE);
}

//---------------------------------------------------------------------------------------------------------------------------
/* Rôle : transforme un point en coordonnées polaires en point en coordonnées cartésiennes
 * Entrée(s) : le centre du cercle dont dépend le point, le rayon de ce cercle, l'angle duquel le point dépend, et l'altitude du cercle
 * Sortie : un PVector contenant les coordonnées du point
 * Précondition(s) : aucune
 */
PVector polToCart (float centreX, float centreY, float rayon, float angle, float alt)
{
  PVector p;
  float x = rayon * cos(angle) + centreX;
  float y = rayon * sin(angle) + centreY;
  float z = alt;
  p = new PVector(x, y, z); // La déclaration aurait pu être bien plus rapide (une ligne), mais comme ça c'est plus joli
  
  return p;
}

//---------------------------------------------------------------------------------------------------------------------------
/* Rôle : trace un arbre de Pythagore
 * Entrée(s) : les points de base sur lesquels s'appuyer pour tracer le niveau suivant, le niveau de récursion actuel
 * Sortie : aucune
 * Précondition(s) : base1 et base2 doivent avoir la même altitude et la même ordonnée, niveau doit être supérieur ou égal à 0
 */
void arbreDePythagore (PVector base1, PVector base2, int niveau, float deg, float R, float G, float B)
{
  float cote = cos(radians(45)) * sqrt( (base2.x-base1.x)*(base2.x-base1.x) + (base2.y-base1.y)*(base2.y-base1.y) );         // le côté des deux nouveaux carrés/cubes
  
  PVector p1  = new PVector(base1.x, base1.y, cote/2);                                                                       // pour pouvoir tracer la figure en 3 dimension, on recréer les points de base avec la nouvelle altitude
  PVector p2  = new PVector(base2.x, base2.y, cote/2);
  PVector p3  = polToCart(base1.x, base1.y, cote, radians(deg + 315), cote/2);                                                     // base1 correspond au point de départ du cercle
                                                                                                                             // cote correspond au rayon
                                                                                                                             // l'angle en degré est calculé via les fonctions trigonométriques puis transformé en radians
                                                                                                                             // l'altitude correspond à la moitié de la taille du côté
  PVector p4  = polToCart(base1.x, base1.y, cote, radians(deg + 225), cote/2);
  PVector p5  = polToCart(base1.x, base1.y, sqrt(2*cote*cote), radians(deg + 270), cote/2);                                        // ici le côté est différent car la diagonale du carré est plus longue que le côté, on applique donc le théorème de Pythagore
  PVector p6  = polToCart(base2.x, base2.y, cote, radians(deg + 315), cote/2);                                                     // on change de point de dépat pour le cercle, p3 est commun aux deux carrés formés
  PVector p7  = polToCart(base2.x, base2.y, sqrt(2*cote*cote), radians(deg + 270), cote/2);
  
  
  PVector p8  = new PVector(base1.x, base1.y, -1*cote/2);                                                                    // de même que plus haut, on créer les deux points de base avec un autre altitude pour pouvoir tracer les faces
  PVector p9  = new PVector(base2.x, base2.y, -1*cote/2);
  PVector p10 = polToCart(base1.x, base1.y, cote, radians(deg + 315), -1*cote/2);                                                  // pour avoir une figure en 3D, on inverse l'altitude et on retrace les même points
  PVector p11 = polToCart(base1.x, base1.y, cote, radians(deg + 225), -1*cote/2);
  PVector p12 = polToCart(base1.x, base1.y, sqrt(2*cote*cote), radians(deg + 270), -1*cote/2);
  PVector p13 = polToCart(base2.x, base2.y, cote, radians(deg + 315), -1*cote/2);
  PVector p14 = polToCart(base2.x, base2.y, sqrt(2*cote*cote), radians(deg + 270), -1*cote/2);
  
  float newR = R-niveau*3;
  float newG = G+niveau*3;
  float newB = B-niveau;
  tracerSixFaces(p1, p4, p5, p3, p8, p11, p12, p10, newR, newG, newB);
  tracerSixFaces(p2, p3, p7, p6, p9, p10, p14, p13, newR, newG, newB);
  
  if (niveau != 0)
  {
    arbreDePythagore(p4, p5, niveau-1, deg-45, newR, newG, newB);
    arbreDePythagore(p7, p6, niveau-1, deg+45, newR, newG, newB);
  }
}

//###########################################################################################################################
//==================================================  Programme principal  ==================================================
//###########################################################################################################################

void setup()
{
  size(800, 800, P3D);
  background(255);
  _cam = new PeasyCam(this, 400);
}

void draw()
{
  background(255);
  // On définie le cube de départ, un cube de 200p de côté
  PVector base1 = new PVector (-100, -100, 100);
  PVector base2 = new PVector (100, -100, 100);
  PVector base3 = new PVector (100, 100, 100);
  PVector base4 = new PVector (-100, 100, 100);
  PVector base5 = new PVector (-100, -100, -100);
  PVector base6 = new PVector (100, -100, -100);
  PVector base7 = new PVector (100, 100, -100);
  PVector base8 = new PVector (-100, 100, -100);
  
  float initR = 139;
  float initG = 69;
  float initB = 19;
  
  tracerSixFaces(base1, base2, base3, base4, base5, base6, base7, base8, initR, initG, initB);
  
  arbreDePythagore(base1, base2, _nbIter, 0, initR, initG, initB);
}
