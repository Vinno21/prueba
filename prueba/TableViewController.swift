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
var db : OpaquePointer?
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
                        
                        let createTable = "CREATE TABLE IF NOT EXISTS CONTACTO(idContacto INTEGER PRIMARY KEY, nombreContacto TEXT, celularContacto NUMERIC,telefonoContacto NUMERIC,correoUsr TEXT)"
                        if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK{
                            showAlerta(Titulo: "error", Mensaje: "No se puede crear la tabla")
                            return
                        }
                        //Al crearse la base de datos abriremos la Vista de Inicio de sesion
                        self.performSegue(withIdentifier: "Inicio", sender: self)
                        showAlerta(Titulo: "Inicia sesion", Mensaje: "Inicia sesion para continuar")
                        return
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
    
    
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
