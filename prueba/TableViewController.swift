//
//  TableViewController.swift
//  prueba
//
//  Created by David on 07/05/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SQLite3

class TableViewController: UITableViewController {
    var correo = ""
    var conta : Contacto?
    var actua = ""
    @IBOutlet var tabla: UITableView!
    var contactos = [Contacto]()
    var db : OpaquePointer?
    let dataJsonUrlClass = JsonClass()
    
    @IBAction func btnAgregarContacto(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueAgregarCon", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Busca la BD y si no encuentra crea la BD
        let fileUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("BDSQLiteAppContactos.sqlite")
        
        if sqlite3_open(fileUrl.path, &db) != SQLITE_OK{
            showAlerta(Titulo: "Error", Mensaje: "No se puede abrir la BD")
            return
        }
        //Realiza una consulta para ver si ha iniciado antes sesion y si no manda a registro
        let consulta = "Select * from CONTACTO"
        if sqlite3_exec(db, consulta, nil, nil, nil) != SQLITE_OK{
            //En caso que no este la sesion iniciada crea la tabla y manda al registro
            
            let createTable = "CREATE TABLE IF NOT EXISTS CONTACTO(idContacto INTEGER PRIMARY KEY, nombreContacto TEXT, celularContacto TEXT,telefonoContacto TEXT,correoUsr TEXT,correoContacto TEXT)"
            if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK{
                showAlerta(Titulo: "error", Mensaje: "No se puede crear la tabla")
                return
            }
            let createTable2 = "CREATE TABLE IF NOT EXISTS USUARIO(nombreUsr TEXT, correoUsr TEXT,contraUsr TEXT)"
            if sqlite3_exec(db, createTable2, nil, nil, nil) != SQLITE_OK{
                showAlerta(Titulo: "error", Mensaje: "No se puede crear la tabla")
                return
            }
            //Al crearse la base de datos abriremos la Vista de Inicio de sesion
            self.performSegue(withIdentifier: "Inicio", sender: self)
            showAlerta(Titulo: "Inicia sesion", Mensaje: "Inicia sesion para continuar")
            return
        }
        //
        
        let datos_a_enviar = ["id": ""] as NSMutableDictionary
        
        //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
        
        dataJsonUrlClass.arrayFromJson(url:"/getContactos.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
            
            DispatchQueue.main.async {
                let cuenta = array_respuesta?.count
                for indice in stride(from: 0, to: cuenta!, by: 1){
                    let contact = array_respuesta?.object(at: indice) as! NSDictionary
                    let idcon = contact.object(forKey: "idContacto") as! String
                    let nomcom = contact.object(forKey: "nombreContacto") as! String
                    let celcon = contact.object(forKey: "celularContacto") as! String
                    let telcon = contact.object(forKey: "telefonoContacto") as! String
                    let corrusr = contact.object(forKey: "correoUsr") as! String
                    let corrcon = contact.object(forKey: "correoContacto") as! String
                    self.contactos.append(Contacto(idContacto: idcon, nombreContacto: nomcom, celularContacto: celcon, telefonoContacto: telcon, correoUsr: corrusr, correoContacto: corrcon))
                    
                    //Borra los datos de la tabla en caso que los tenga para despues actualizarlos
                    var stmt: OpaquePointer?
                    
                    let deleteStatementString = "DELETE FROM CONTACTO"
                    if sqlite3_prepare_v2(self.db, deleteStatementString, -1, &stmt, nil) ==
                        SQLITE_OK {
                        if sqlite3_step(stmt) == SQLITE_DONE {
                            print("\nSuccessfully deleted row.")
                        } else {
                            print("\nCould not delete row.")
                        }
                    } else {
                        print("\nDELETE statement could not be prepared")
                    }
                    
                    
                    
                    
                    //Inserta los datos del JSON
                    
                    let sentencia = "INSERT INTO CONTACTO(idContacto, nombreContacto, celularContacto,telefonoContacto,correoUsr ,correoContacto) VALUES (?,?,?,?,?,?)"
                    
                    if sqlite3_prepare(self.db, sentencia, -1, &stmt, nil) != SQLITE_OK{
                        self.showAlerta(Titulo: "Error", Mensaje: "Error al ligar sentencia")
                        return
                    }
                    if sqlite3_bind_int(stmt, 1, (idcon as NSString).intValue) != SQLITE_OK{
                        self.showAlerta(Titulo: "Error", Mensaje: "En el 1er parametro id")
                        return
                    }
                    if sqlite3_bind_text(stmt, 2, nomcom, -1, nil) != SQLITE_OK{
                        self.showAlerta(Titulo: "Error", Mensaje: "En el 2do parametro nomcom")
                        return
                    }
                    if sqlite3_bind_text(stmt, 3, celcon, -1, nil) != SQLITE_OK{
                        self.showAlerta(Titulo: "Error", Mensaje: "En el 3er parametro celcon")
                        return
                    }
                    if sqlite3_bind_text(stmt, 4, telcon, -1, nil) != SQLITE_OK{
                        self.showAlerta(Titulo: "Error", Mensaje: "En el 4to parametro telcon")
                        return
                    }
                    if sqlite3_bind_text(stmt, 5, corrusr, -1, nil) != SQLITE_OK{
                        self.showAlerta(Titulo: "Error", Mensaje: "En el 5to parametro corrusr")
                        return
                    }
                    if sqlite3_bind_text(stmt, 6, corrcon, -1, nil) != SQLITE_OK{
                        self.showAlerta(Titulo: "Error", Mensaje: "En el 6to parametro corrcon")
                        return
                    }
                    
                    if sqlite3_step(stmt) == SQLITE_DONE{
                    }
                    else
                    {
                        print("Datos no guardados 2")
                        self.tabla.reloadData()
                        return
                    }
                    //
                    
                    self.tabla.reloadData()
                }
            }
        }
        //
        tabla.reloadData()
    }
    func showAlerta (Titulo: String, Mensaje: String){
        //Crea un alerta
        let alert = UIAlertController(title: Titulo, message: Mensaje, preferredStyle: UIAlertController.Style.alert)
        //Agreaga un boton
        alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertAction.Style.default, handler: nil))
        //Muestra la alerta
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contactos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda") as! TableViewCell
        let con : Contacto
        con = contactos[indexPath.row]
        cell.txtnombreContacto.text = con.nombreContacto
        cell.txtcelularContacto.text = con.celularContacto
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        conta = contactos[indexPath.row]
        self.performSegue(withIdentifier: "segueeditar", sender: self)
        
        
    }
    
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     */
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueeditar"{
            let vc = segue.destination as! ViewController
            vc.cont = self.conta
        }
        if segue.identifier == "segueAgregarCon"{
            let vc = segue.destination as! ViewController
            vc.correo = self.correo
        }
    }
}
