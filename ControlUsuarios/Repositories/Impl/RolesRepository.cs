﻿using System;
using ControlUsuarios.Models;
namespace ControlUsuarios.Repositories.Impl
{
    public class RolesRepository : IRolesRepository
    {
        private readonly userContext _context;
        public RolesRepository(userContext context)
        {
            _context = context;
        }

        public IEnumerable<Role> GetAll()
        {
            return _context.Roles;
        }
    }
}

