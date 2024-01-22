﻿using Repositories.Dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories.Interfaces
{
    public interface IAccountManageRepository
    {
        Task<IEnumerable<AccountManageDTO>> GetAll();
        Task<AccountManageDTO> GetById(int id);
        void Update(AccountManageDTO account);
        void Delete(int id);
        Task<IEnumerable<RoleDTO>> GetRole();
    }
}
