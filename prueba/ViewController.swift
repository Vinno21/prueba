//
//  ViewController.swift
//  prueba
//
//  Created by David on 25/04/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    var correo = ""
    var db : OpaquePointer?
    let dataJsonUrlClass = JsonClass()
    var cont : Contacto?
    
    @IBOutlet weak var txtnomContacto: UITextField!
    @IBOutlet weak var txtcelContacto: UITextField!
    @IBOutlet weak var txttelContacto: UITextField!
    @IBOutlet weak var txtcorreoContacto: UITextField!
    @IBOutlet weak var txtidContacto: UITextField!
    @IBOutlet weak var txtcorrUsr: UILabel!
    var corrusr = ""
    @IBAction func btnAceptar(_ sender: UIButton) {
        
        let idcon = txtidContacto.text
        let nomcon = txtnomContacto.text
        let celcon = txtcelContacto.text
        let telcon = txttelContacto.text
        corrusr = txtcorrUsr.text!
        let corrcon = txtcorreoContacto.text
        
        //La siguiente condicion checa que las cajas de texto no esten vacias
        if txtnomContacto.hasText != false && txtcelContacto.hasText != false{
            if txtidContacto.text == ""{ //Si el idContacto esta vacio el codigo de adentro agrega si no actualiza
                
                
                //Checamos que la base de datos exista para abrirla
                let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteAppContactos.sqlite")
                
                if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
                    showAlerta(Titulo: "Error", Mensaje: "No se puede abrir la BD")
                    return
                }
                //Insertamos los datos de el contacto
                var stmt: OpaquePointer?
                let sentencia = "INSERT INTO CONTACTO(nombreContacto, celularContacto,telefonoContacto,correoUsr ,correoContacto) VALUES (?,?,?,?,?)"
                if sqlite3_prepare(self.db, sentencia, -1, &stmt, nil) != SQLITE_OK{
                    self.showAlerta(Titulo: "Error", Mensaje: "Error al ligar sentencia")
                    return
                }
                if sqlite3_bind_text(stmt, 1, nomcon, -1, nil) != SQLITE_OK{
                    self.showAlerta(Titulo: "Error", Mensaje: "En el 2do parametro nomcom")
                    return
                }
                if sqlite3_bind_text(stmt, 2, celcon, -1, nil) != SQLITE_OK{
                    self.showAlerta(Titulo: "Error", Mensaje: "En el 3er parametro celcon")
                    return
                }
                if sqlite3_bind_text(stmt, 3, telcon, -1, nil) != SQLITE_OK{
                    self.showAlerta(Titulo: "Error", Mensaje: "En el 4to parametro telcon")
                    return
                }
                if sqlite3_bind_text(stmt, 4, corrusr, -1, nil) != SQLITE_OK{
                    self.showAlerta(Titulo: "Error", Mensaje: "En el 5to parametro corrusr")
                    return
                }
                if sqlite3_bind_text(stmt, 5, corrcon, -1, nil) != SQLITE_OK{
                    self.showAlerta(Titulo: "Error", Mensaje: "En el 6to parametro corrcon")
                    return
                }
                if sqlite3_step(stmt) == SQLITE_DONE{
                    print("Guardados en Sqlite")
                }
                else
                {
                    self.showAlerta(Titulo: "Error", Mensaje: "Contactos no guardados")
                    return
                }
                
                //JSON WebService para insertar contacto
                let datos_a_enviar = ["nombreContacto": nomcon!, "celularContacto":celcon!, "telefonoContacto":telcon!, "correoUsr":corrusr, "correoContacto" : corrcon!] as NSMutableDictionary
                //Ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                dataJsonUrlClass.arrayFromJson(url:"/insertContacto.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                    DispatchQueue.main.async {
                        let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                        //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                        if let suc = diccionario_datos.object(forKey: "success") as! String?{
                            if(suc == "200"){
                                print("insertado en la BD JSON")
                            }
                        }else{
                            self.showAlerta(Titulo: "Error", Mensaje: "Error al insertar")
                        }
                    }
                }
                self.performSegue(withIdentifier: "contactagreg", sender: self)
                
            }else{
                //Codigo para actualizar Contacto
                //JSON WebService para actualizar contacto
                
                let datos_a_enviar = ["idContacto": idcon! ,"nombreContacto": nomcon!,"celularContacto":celcon!,"telefonoContacto":telcon!, "correoContacto" : corrcon!] as NSMutableDictionary
                //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
                
                dataJsonUrlClass.arrayFromJson(url:"/updateContacto.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                    DispatchQueue.main.async {
                        let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                        //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                        if let suc = diccionario_datos.object(forKey: "success") as! String?{
                            if(suc == "200"){
                                print("actualizado en la BD JSON")
                                self.performSegue(withIdentifier: "contactoactual", sender: self)
                            }
                        }else{
                            self.showAlerta(Titulo: "Error", Mensaje: "Error al actualizar")
                        }
                    }
                }
            }
        }else{
            showAlerta(Titulo: "Faltan Datos", Mensaje: "Falta Nombre o Celular del contacto")
        }
        
        
    }
    
    @IBAction func btnBorrar(_ sender: UIButton) {
        //Codigo para borrar Contacto
        //JSON WebService para borrar contacto
        let idcon = txtidContacto.text
        if idcon == ""{
            return
        }
        let datos_a_enviar = ["idContacto": idcon!] as NSMutableDictionary
        //Ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
        dataJsonUrlClass.arrayFromJson(url:"/deleteContacto.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
            DispatchQueue.main.async {
                let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                if let suc = diccionario_datos.object(forKey: "success") as! String?{
                    if(suc == "200"){
                        print("actualizado en la BD JSON")
                        self.performSegue(withIdentifier: "deleteCon", sender: self)
                    }
                }else{
                    self.showAlerta(Titulo: "Error", Mensaje: "Error al actualizar")
                }
            }
        }
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        //Toma el valor de el correo en caso que sea la primera vez que se agrega un contacto
        txtcorrUsr.text = correo
        
        //Llena los datos en caso que se este editando o que se busque borrar un contacto
        if cont?.correoUsr != nil{
            txtcorreoContacto.text = cont?.correoContacto
            txtcorrUsr.text = cont?.correoUsr
            txtnomContacto.text = cont?.nombreContacto
            txtcelContacto.text = cont?.celularContacto
            txttelContacto.text = cont?.telefonoContacto
            txtidContacto.text = cont?.idContacto
        }
        
    }
    
    
    func showAlerta (Titulo: String, Mensaje: String){
        //Crea un alerta
        let alert = UIAlertController(title: Titulo, message: Mensaje, preferredStyle: UIAlertController.Style.alert)
        //Agreaga un boton
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        //Muestra la alerta
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "deleteCon"{ //Manda un 1 en caso que se actualize un contacto
            let tvc = segue.destination as! TableViewController
            let actual = "1"
            tvc.actua = actual
        }
        if segue.identifier == "contactoactual"{ //Manda un 1 en caso que se actualize un contacto
            let tvc = segue.destination as! TableViewController
            let actual = "1"
            tvc.correo = self.corrusr
            tvc.actua = actual
        }
        if segue.identifier == "contactagreg"{
            let tvc = segue.destination as! TableViewController
            tvc.correo = self.corrusr
        }
    }
    
    
    
}
