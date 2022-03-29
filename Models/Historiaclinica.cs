﻿using System;
using System.Collections.Generic;

#nullable disable

namespace API_Hospital_Boca.Models
{
    public partial class Historiaclinica
    {
        public int IdHistoriaClinica { get; set; }
        public string FkPaciente { get; set; }
        public int? FkHospital { get; set; }
        public DateTime? FechaElab { get; set; }

        public virtual Hospitale FkHospitalNavigation { get; set; }
        public virtual Paciente FkPacienteNavigation { get; set; }
    }
}
