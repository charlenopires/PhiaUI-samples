defmodule PhiaDemo.FakeData do
  @moduledoc "Hardcoded fake data for the PhiaUI dashboard demo."

  def stats do
    [
      %{
        title: "Receita Total",
        value: "R$ 284.590",
        trend: :up,
        trend_value: "+12,5%",
        description: "vs. mês anterior"
      },
      %{
        title: "Usuários Ativos",
        value: "12.847",
        trend: :up,
        trend_value: "+8,2%",
        description: "vs. mês anterior"
      },
      %{
        title: "Pedidos",
        value: "3.924",
        trend: :neutral,
        trend_value: "→ 0,1%",
        description: "vs. mês anterior"
      },
      %{
        title: "Conversão",
        value: "4,7%",
        trend: :down,
        trend_value: "-0,3%",
        description: "vs. mês anterior"
      }
    ]
  end

  def recent_orders do
    [
      %{id: "#4521", cliente: "Ana Costa", produto: "Plano Pro", valor: "R$ 299,00", status: :pago, data: "01/03/2026"},
      %{id: "#4520", cliente: "Bruno Lima", produto: "Plano Starter", valor: "R$ 99,00", status: :pendente, data: "01/03/2026"},
      %{id: "#4519", cliente: "Carla Souza", produto: "Plano Enterprise", valor: "R$ 999,00", status: :pago, data: "28/02/2026"},
      %{id: "#4518", cliente: "Diego Melo", produto: "Plano Pro", valor: "R$ 299,00", status: :cancelado, data: "28/02/2026"},
      %{id: "#4517", cliente: "Elena Rocha", produto: "Plano Starter", valor: "R$ 99,00", status: :pago, data: "27/02/2026"},
      %{id: "#4516", cliente: "Fábio Nunes", produto: "Plano Pro", valor: "R$ 299,00", status: :pago, data: "27/02/2026"},
      %{id: "#4515", cliente: "Gabi Torres", produto: "Plano Enterprise", valor: "R$ 999,00", status: :pendente, data: "26/02/2026"},
      %{id: "#4514", cliente: "Hugo Alves", produto: "Plano Starter", valor: "R$ 99,00", status: :pago, data: "26/02/2026"},
      %{id: "#4513", cliente: "Ísis Ferreira", produto: "Plano Pro", valor: "R$ 299,00", status: :pago, data: "25/02/2026"},
      %{id: "#4512", cliente: "João Ribeiro", produto: "Plano Enterprise", valor: "R$ 999,00", status: :cancelado, data: "25/02/2026"}
    ]
  end

  def users do
    [
      %{id: 1, nome: "Ana Costa", email: "ana@acme.com", role: "Admin", status: :ativo, cadastro: "Jan 2024"},
      %{id: 2, nome: "Bruno Lima", email: "bruno@acme.com", role: "Editor", status: :ativo, cadastro: "Mar 2024"},
      %{id: 3, nome: "Carla Souza", email: "carla@acme.com", role: "Viewer", status: :inativo, cadastro: "Jun 2024"},
      %{id: 4, nome: "Diego Melo", email: "diego@acme.com", role: "Editor", status: :ativo, cadastro: "Ago 2024"},
      %{id: 5, nome: "Elena Rocha", email: "elena@acme.com", role: "Admin", status: :ativo, cadastro: "Set 2024"},
      %{id: 6, nome: "Fábio Nunes", email: "fabio@acme.com", role: "Viewer", status: :pendente, cadastro: "Nov 2024"},
      %{id: 7, nome: "Gabi Torres", email: "gabi@acme.com", role: "Editor", status: :ativo, cadastro: "Dez 2024"},
      %{id: 8, nome: "Hugo Alves", email: "hugo@acme.com", role: "Viewer", status: :inativo, cadastro: "Fev 2025"}
    ]
  end

  def revenue_by_month do
    [
      %{mes: "Mar", value: 18_500},
      %{mes: "Abr", value: 21_300},
      %{mes: "Mai", value: 19_800},
      %{mes: "Jun", value: 24_100},
      %{mes: "Jul", value: 22_700},
      %{mes: "Ago", value: 26_400},
      %{mes: "Set", value: 23_900},
      %{mes: "Out", value: 28_600},
      %{mes: "Nov", value: 31_200},
      %{mes: "Dez", value: 35_800},
      %{mes: "Jan", value: 29_400},
      %{mes: "Fev", value: 33_100}
    ]
  end

  def visits_by_month do
    [
      %{mes: "Mar", value: 4_200},
      %{mes: "Abr", value: 5_800},
      %{mes: "Mai", value: 5_100},
      %{mes: "Jun", value: 6_900},
      %{mes: "Jul", value: 7_400},
      %{mes: "Ago", value: 8_100},
      %{mes: "Set", value: 7_600},
      %{mes: "Out", value: 9_200},
      %{mes: "Nov", value: 10_500},
      %{mes: "Dez", value: 12_300},
      %{mes: "Jan", value: 9_800},
      %{mes: "Fev", value: 11_200}
    ]
  end

  def traffic_by_source do
    [
      %{source: "Busca Orgânica", value: 42, color: "fill-primary"},
      %{source: "Direto", value: 25, color: "fill-secondary"},
      %{source: "Redes Sociais", value: 18, color: "fill-accent"},
      %{source: "E-mail", value: 10, color: "fill-muted-foreground"},
      %{source: "Outros", value: 5, color: "fill-border"}
    ]
  end

  def top_products do
    [
      %{name: "Plano Enterprise", revenue: "R$ 11.988", orders: 12, pct: 100},
      %{name: "Plano Pro", revenue: "R$ 8.970", orders: 30, pct: 75},
      %{name: "Plano Starter", revenue: "R$ 2.970", orders: 30, pct: 25},
      %{name: "Add-on Analytics", revenue: "R$ 1.490", orders: 15, pct: 12},
      %{name: "Suporte Premium", revenue: "R$ 990", orders: 9, pct: 8}
    ]
  end

  def order_summary do
    %{
      total_revenue: "R$ 26.418",
      avg_ticket: "R$ 359,00",
      paid_amount: "R$ 22.278"
    }
  end

  def analytics_stats do
    [
      %{title: "Visitantes Únicos", value: "98.421", trend: :up, trend_value: "+14,3%", description: "vs. mês anterior"},
      %{title: "Páginas por Sessão", value: "3,8", trend: :up, trend_value: "+0,4", description: "vs. mês anterior"},
      %{title: "Taxa de Rejeição", value: "32,1%", trend: :down, trend_value: "-2,1%", description: "vs. mês anterior"}
    ]
  end
end
