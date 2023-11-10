// parcial Objetos  - Harry Botter

// modelo Bots
class Bot {
	var property cargaElectrica // un int
	var property aceitePuro // un bool
	method estaActivo() = cargaElectrica > 0
	method disminuirCargaElectrica(n) {cargaElectrica -= n}
	method llevarCargaA0() {self.cargaElectrica(0)}
	method ensuciarAceite() {self.aceitePuro(false)}
}

// sombrero seleccionador
object sombrero inherits Bot (cargaElectrica = 10, aceitePuro = true){
	var property ultimaCasa = hufflepuf							// guarda la última casa que asignó
	const casas = [gryffindor, slytherin, ravenclaw, hufflepuf]	// casas posibles
	method proximaCasa() {										//en base a la última casa que asignó, sabe cuál es la próxima a asignar
		ultimaCasa = ultimaCasa.proximaCasa()
		return ultimaCasa										// actualiza la última casa asignada
	}
	method asignarCasa(estudiante) = estudiante.casa(self.proximaCasa())
// ejericio 1 - asignar a un grupo de estudiantes
	method asignarCasaAGrupo(coleccionEstudiantes) = coleccionEstudiantes.forEach{estudiante => self.asignarCasa(estudiante)}
	override method ensuciarAceite() { self.aceitePuro() }
}

// bots Estudiantes y Profesores
class Estudiante inherits Bot{
	var property casa
	var property nombre = []
	var property hechizosAprendidos = []
	method esExperimentado() = hechizosAprendidos.size() > 3 && cargaElectrica > 50
	method asistirAclase(materia) = materia.enseniarHechizo(self)
	method lanzarHechizoA(hechizo,hechizado) {
		if (self.puedeLanzarHechizo(hechizo)) hechizo.lanzarA(hechizado) 
		else throw new DomainException() ("este estudiante no puede lanzar este hechizo") }
	method aprenderHechizo(nuevoHechizo) = hechizosAprendidos.add(nuevoHechizo)
	method puedeLanzarHechizo(hechizo) = self.estaActivo() && hechizosAprendidos.contains(hechizo) && hechizo.cumpleCondiciones(self) // acá todavía no se contemplan las condiciones del hechizo
}
class Profesor inherits Estudiante{
	var property materiasDictadas // una cantidad
	override method esExperimentado() = super() && materiasDictadas >= 2
	override method disminuirCargaElectrica(n) {}
	override method llevarCargaA0() {cargaElectrica = cargaElectrica/2}
// ejercicio 2 - crear una materia, un porfesor puede crear una materia q él mismo dictará, es por eso que solo puede enseñar un hechizo que él sepa
	method crearMateria() = new Materia (hechizoEnseniado = hechizosAprendidos.anyOne(), profesor = self)
}

// Casas
class Casa {
	var property estudiantes = []
	method esPeligrosa() = false
// ejercicio 5 - lanzar hechizo entre todos los integrantes de la casa
	method lanzarHechizo(){
		estudiantes.forEach({estudiante => estudiante.lanzarHechizoA(estudiante.hechizosAprendidos().last(), youKnowWho)})
	}
}
object gryffindor inherits Casa{
	method proximaCasa() = slytherin
}
object slytherin inherits Casa{
	override method esPeligrosa() = true
	method proximaCasa() = ravenclaw
}
object ravenclaw inherits Casa{
	method estudiantesAceitePuro() = estudiantes.filter({estudiante => estudiante.aceitePuro()}).size()
	override method esPeligrosa() = estudiantes.size()/2 > self.estudiantesAceitePuro()
	method proximaCasa() = hufflepuf
}
object hufflepuf inherits Casa{
	method estudiantesAceitePuro() = estudiantes.filter({estudiante => estudiante.aceitePuro()}).size()
	override method esPeligrosa() = estudiantes.size()/2 > self.estudiantesAceitePuro()
	method proximaCasa() = gryffindor
}

// Hechizos
class Hechizo{
	method cumpleCondiciones(lanzador)
	method lanzarA(hechizado)			
}
object inmobulus inherits Hechizo {
	override method cumpleCondiciones(lanzador) = true
	override method lanzarA(estudiante) = estudiante.disminuirCargaElectrica(50)
}
object spectumSempra inherits Hechizo{
	override method cumpleCondiciones(lanzador) = lanzador.esExperimentado()
	override method lanzarA(hechizado) = hechizado.ensuciarAceite()
}
object avadakedabra inherits Hechizo{
	override method cumpleCondiciones(lanzador) = ! lanzador.aceitePuro()
	override method lanzarA(hechizado) = hechizado.llevarCargaA0()
}
class HechizoComun inherits Hechizo{
	method cumpleCondiciones(lanzador,cant)	= lanzador.cargaElectrica() > cant // no llegué a arreglar
	method lanzarA(hechizado,cant)	= hechizado.disminuirCargaElectrica(cant)
}


// Materias
class Materia{
	var property hechizoEnseniado
	var property profesor
	method enseniarHechizo(estudiante) = estudiante.aprenderHechizo(hechizoEnseniado) 
// ejercicio 3 - enseñar un hechizo a un grupo de estudiantes que  asisten a clase
	method enseniarHechizoAgrupo(coleccionEstudiantes) = coleccionEstudiantes.forEach{estudiante => self.enseniarHechizo(estudiante)}
}

// materia inventada - no llegué
//object algoritmosYestructurasDeHechizos inherits Materia (hechizoEnseniado = bubbleSortName, profesor = albus){}

// he who must not be named
object youKnowWho inherits Estudiante (cargaElectrica = 100, aceitePuro = false, casa = slytherin){}

// albus
object albus inherits Profesor (
	aceitePuro = true, 
	cargaElectrica = 100, 
	casa = gryffindor, 
	nombre = "albus",
	materiasDictadas = 10){}

// ---------- Objetos para agilizar tests ----------

object harry inherits Estudiante (
	aceitePuro = true, 
	cargaElectrica = 80, 
	casa = 0, 
	nombre = "harry", 
	hechizosAprendidos = []	){}
	
object draco inherits Estudiante (
	aceitePuro = true, 
	cargaElectrica = 100, 
	casa = 0, 
	nombre = "draco", 
	hechizosAprendidos = [] ){}
	
object hermione inherits Estudiante (
	aceitePuro = true, 
	cargaElectrica = 100, 
	casa = 0, 
	nombre = "hermione", 
	hechizosAprendidos = []){}
	
object boti inherits Estudiante (
	aceitePuro = true, 
	cargaElectrica = 100, 
	casa = 0, 
	nombre = "ron", 
	hechizosAprendidos = [] ){}
	
object chatGPT inherits Estudiante (
	aceitePuro = true, 
	cargaElectrica = 100, 
	casa = 0, 
	nombre = "ron", 
	hechizosAprendidos = [] ){}

/* Nuevo hechizo - bubble sort, ordena alfabéticamente las letras del nombre del hechizado
object bubbleSortName inherits Hechizo{ 
	override method cumpleCondiciones(lanzador) = lanzador.nombre().size() > 5 // el lanzador debe tener más de 5 letras en su nombre 
	override method lanzarA(hechizado) = hechizado.nombre().sortBy()// revisar
}*/ //no llegué
