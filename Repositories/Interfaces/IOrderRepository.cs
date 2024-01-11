﻿using Repositories.Dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Repositories.Interfaces
{
    public interface IOrderRepository
    {
        Task<IEnumerable<OrderDTO>> GetAll();
        Task<OrderDTO> GetById(int id);
        Task<IEnumerable<OrderDetail>> GetOrderDetail(int id);
    }
}
