#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# 3rd party imports
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd



df_noopt = pd.read_csv('metrics/hive_query_perf_without_opt.csv').sort_values('Query')
df_opt = pd.read_csv('metrics/hive_query_perf_with_opt.csv').sort_values('Query')


queries = df_noopt['Query']
x = np.arange(len(queries)) 
width = 0.35  # width of bars


fig, ax = plt.subplots(figsize=(12, 7))

bars1 = ax.bar(x - width/2, df_noopt['Duration (s)'], width, label='Without Optimization', color='#FF6F61', alpha=0.85)
bars2 = ax.bar(x + width/2, df_opt['Duration (s)'], width, label='With Optimization', color='#4CAF50', alpha=0.85)

ax.set_xlabel('Queries', fontsize=13, weight='bold')
ax.set_ylabel('Response Time (s)', fontsize=13, weight='bold')
ax.set_title('Hive Query Performance Comparison', fontsize=16, weight='bold')
ax.set_xticks(x)
ax.set_xticklabels(queries, rotation=45, ha='right', fontsize=11)

ax.yaxis.grid(True, linestyle='--', alpha=0.6)
ax.legend(fontsize=12)

for bars in [bars1, bars2]:
    ax.bar_label(bars, fmt='%.2f', padding=3, fontsize=10)

plt.tight_layout()
plt.savefig('metrics/hive_query_perf_comparison.png', dpi=300)
plt.show()
