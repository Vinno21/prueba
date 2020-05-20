//
//  ViewControllerRegistro.swift
//  prueba
//
//  Created by David on 08/05/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit
import SQLite3


class ViewControllerRegistro: UIViewController {
    var db : OpaquePointer?
    let dataJsonUrlClass = JsonClass()
    var correos = ""
    
    @IBOutlet weak var txtcorreoRegis: UITextField!
    @IBOutlet weak var txtnombreRegis: UITextField!
    @IBOutlet weak var txtcontraRegis: UITextField!
    @IBAction func btnregistroUsuario(_ sender: UIButton) {
        
            //Extraemos el valor del campo de texto (ID usuario)
              let corr_usr = txtcorreoRegis.text
              let nom_usr = txtnombreRegis.text
              let con_usr = txtcontraRegis.text
                            
               //Si corr_usr.text no tienen ningun valor terminamos la ejecución
               if corr_usr == ""{
                   return
               }
               if nom_usr == ""{
                   return
               }
               if con_usr == ""{
                   return
               }
               //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
               let datos_a_enviar = ["correoUsr": corr_usr!,"nombreUsr":nom_usr!,"contraUsr":con_usr!] as NSMutableDictionary
               //Ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
               dataJsonUrlClass.arrayFromJson(url:"/insertUsuario.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
                   DispatchQueue.main.async {
                       let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                       //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                       if let suc = diccionario_datos.object(forKey: "success") as! String?{
                           if(suc == "200"){
                            self.correos = corr_usr!
                            self.performSegue(withIdentifier: "usuarioregistrado", sender: self)
                            
                           }
                       }else{
                           self.showAlerta(Titulo: "Error", Mensaje: "Error al crear cuenta")
                       }
                   }
               }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Do any additional setup after loading the view.
        
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
        //Manda el correo del usuario para agregar al contacto
            let vc = segue.destination as! ViewController
            vc.correo = correos
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
