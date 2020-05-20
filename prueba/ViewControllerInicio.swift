//
//  ViewControllerInicio.swift
//  prueba
//
//  Created by David on 17/05/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class ViewControllerInicio: UIViewController {
    let dataJsonUrlClass = JsonClass()
    var Contactos = [Contacto]()
    
    @IBOutlet weak var txtcorreoUsuario: UITextField!
    
    @IBOutlet weak var txtcontraUsuario: UITextField!
    
    
    @IBAction func btninicioSesion(_ sender: UIButton) {
        
        
        //extraemos el valor del campo de texto (correousuario)
        let corr_usr = txtcorreoUsuario.text
        
        //si idText.text no tienen ningun valor terminamos la ejecución
        if corr_usr == ""{
            self.showAlerta(Titulo: "Datos", Mensaje: "Faltan datos de entrada")
            return
        }
        
        //Creamos un array (diccionario) de datos para ser enviados en la petición hacia el servidor remoto, aqui pueden existir N cantidad de valores
        let datos_a_enviar = ["correoUsr": corr_usr!] as NSMutableDictionary
        
        //ejecutamos la función arrayFromJson con los parámetros correspondientes (url archivo .php / datos a enviar)
        
        dataJsonUrlClass.arrayFromJson(url:"/getUsuario.php",datos_enviados:datos_a_enviar){ (array_respuesta) in
            DispatchQueue.main.async {
                let diccionario_datos = array_respuesta?.object(at: 0) as! NSDictionary
                
                
                //ahora ya podemos acceder a cada valor por medio de su key "forKey"
                if let contra = diccionario_datos.object(forKey: "contraUsr") as! String?{
                    if(contra == self.txtcontraUsuario.text){
                        
                        self.performSegue(withIdentifier: "iniciosesion", sender: self)
                        
                    }
                }else{
                    self.showAlerta(Titulo: "Error", Mensaje: "Contraseña o Correo incorrecto")
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
        if segue.identifier == "iniciosesion"{
            let vc = segue.destination as! TableViewController
            vc.correo = txtcorreoUsuario.text!
        }
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
